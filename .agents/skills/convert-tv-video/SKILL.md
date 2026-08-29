---
name: convert-tv-video
description: >-
  use this skill to convert videos to playable format on old sony bravia tv
disable-model-invocation: true
---

# Convert video for old Sony Bravia TV

Make USB/media-player files play on ~2014–2016 Sony Bravia sets. Prefer **probe → remux/re-encode only what’s broken → verify**. Do not invent Python wrappers unless the user asks.

## Target format (reliable on old Bravia)

| Stream | Use | Avoid |
|--------|-----|--------|
| Container | `.mp4` (safest) or simple `.mkv` | WebM-only assumptions |
| Video | **H.264 High, level ≤ 4.1, 8-bit `yuv420p`** | AV1, VP9, HEVC Main10 if the set already fails it |
| Audio | **AAC-LC** stereo (or AC3 / E-AC3) | **Opus**, Vorbis, DTS, TrueHD |
| Subs | Soft **SRT** / `mov_text` (hit-or-miss on TV) | ASS/SSA + fonts (often ignored) |

Proven-safe encode profile:

- Video: `h264` High `@ Level 4.1`, `yuv420p` (8-bit)
- Audio: `aac`, stereo, ~160–192k
- Flags: `-movflags +faststart` for MP4

## Diagnose first

```bash
ffprobe -hide_banner -show_streams -show_format FILE
```

Common USB failures on old Bravia:

1. **AV1 / VP9 + Opus** (typical yt-dlp / Parabolic / YouTube) → must re-encode video **and** audio
2. **HEVC works but Opus audio** → often refuse whole file → copy video, re-encode audio only
3. **10-bit (`yuv420p10le`)** fed into consumer `h264_nvenc` without convert → `10 bit encode not supported`
4. Soft ASS subs missing on TV → expected; burn-in only if user wants on-screen text

If one file in a set already plays, match **its** codecs (e.g. H.264+AAC or HEVC+E-AC3), not the broken one.

## Prefer least work

1. **HDMI / stick / Plex** — no convert
2. **Remux / audio-only** — `-c:v copy` when video is already TV-safe
3. **Full NVENC re-encode** — when video is AV1/VP9/bad HEVC/10-bit path fails

Audio-only fix (video already OK):

```bash
ffmpeg -i INPUT -map 0:v:0 -map 0:a:0 -c:v copy -c:a aac -b:a 192k -ac 2 -movflags +faststart OUTPUT.mp4
```

## NVIDIA GPU (NVENC) — correct FFmpeg usage

Hardware: laptop **RTX 3050**-class is fine. NVENC is a **separate** block; low “GPU %” in nvidia-smi is normal while `utilization.encoder` is high.

### Required for 10-bit / HDR-ish sources → H.264

Consumer `h264_nvenc` is **8-bit only**. Always convert to `yuv420p` before encode.

**Preferred (keep frames on GPU):**

```bash
ffmpeg -hwaccel cuda -hwaccel_output_format cuda -i INPUT \
  -map 0:v:0 -map 0:a:0? \
  -vf "scale_cuda=format=yuv420p" \
  -c:v h264_nvenc -preset p4 -rc vbr -cq 23 -b:v 0 \
  -profile:v high -level 4.1 \
  -c:a aac -b:a 160k -ac 2 \
  -movflags +faststart \
  OUTPUT.mp4
```

**Fallback if `scale_cuda` fails:**

```bash
ffmpeg -hwaccel cuda -i INPUT \
  -map 0:v:0 -map 0:a:0? \
  -vf "hwdownload,format=nv12,format=yuv420p" \
  -c:v h264_nvenc -preset p4 -rc vbr -cq 23 -b:v 0 \
  -profile:v high -level 4.1 -pix_fmt yuv420p \
  -c:a aac -b:a 160k -ac 2 \
  -movflags +faststart \
  OUTPUT.mp4
```

### Do / don’t

- **Do** use `-hwaccel cuda` + format convert to 8-bit for NVENC H.264
- **Do** watch `nvidia-smi dmon -s u` (`enc` / `dec` / memory)
- **Don’t** pass 10-bit CUDA frames straight into `h264_nvenc`
- **Don’t** expect 4× speed from 4 parallel jobs on a **single** NVENC engine
- Parallelism: **2–3** ffmpeg jobs is reasonable on 4 GB laptop 3050; VRAM for 480p is ~100–150 MiB/job, 1080p ~300 MiB/job — session limit on modern drivers is high (≈8), bottleneck is one NVENC + TGP

### Intel QSV (optional backup)

```bash
ffmpeg -hwaccel qsv -c:v hevc_qsv -i INPUT \
  -c:v h264_qsv -global_quality 22 \
  -c:a aac -b:a 160k -ac 2 OUTPUT.mp4
```

Prefer NVIDIA NVENC when available; don’t dual-encode one file on both GPUs.

## yt-dlp / Parabolic prevention

Prefer H.264+AAC at download time instead of converting later:

```bash
yt-dlp -f "bv*[vcodec^=avc1]+ba[acodec^=mp4a]/b[ext=mp4]/b" --merge-output-format mp4 URL
```

## Workflow for the agent

1. `ffprobe` inputs; summarize video/audio/subtitle codecs and bit depth
2. Choose remux vs full re-encode from the tables above
3. Run ffmpeg (NVENC recipe when full re-encode); fix 10-bit with `scale_cuda=format=yuv420p`
4. `ffprobe` output: confirm `h264` + `yuv420p` + `aac` (or the known-good pair)
5. Tell user the output path; mention soft subs may not show on old Bravia

## Out of scope

- Custom Python CLIs / batch frameworks unless the user explicitly asks
- Burning ASS/fonts unless requested
- Assuming every Bravia supports HEVC/Opus/AV1
