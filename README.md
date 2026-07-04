# eryu

A self-hosted music player for listening together. Powered by NetEase Cloud Music.

## Features

- **Search & Play** — Full NetEase Cloud Music catalog with VIP-quality streams
- **Listen Together** — Real-time two-person sync (play/pause/seek/track) via long-polling, with presence and activity toasts — no WebSocket dependency
- **Synced Lyrics** — Real-time scrolling lyrics with tap-to-seek and draggable progress bar
- **Lyric Quotes** — Long-press any lyric line to save it into the song's permanent memory
- **Translation** — Foreign songs automatically show Chinese translation
- **Playlists** — Create and manage multiple playlists
- **Roam Mode** — Auto-discover similar songs when the queue is empty
- **Song Notes** — Save feelings, favorite lines, and tags for each song
- **Spectrum Analysis** — BPM, key, and energy curve analysis (optional, requires librosa)
- **Remote Play** — Push songs to the player from any device via API
- **Daily Recommendations** — Personalized song suggestions
- **CDN Fallback** — Automatic node switching for overseas servers
- **Zero Dependencies** — Pure Python stdlib server, vanilla JS frontend

## Quick Start

```bash
git clone https://github.com/sebastianevan200-stack/eryu.git
cd eryu

# Add your NetEase Cloud Music cookie
echo "MUSIC_U=your_cookie_here" > server/.netease_cred

# Run
python3 server/eryu.py
```

Open `http://localhost:9090` in your browser. The auth token is auto-generated and saved to `server/.secret` on first run.

## Configuration

| Environment Variable | Default | Description |
|---|---|---|
| `PORT` | `9090` | Server port |
| `MUSIC_U` | — | NetEase Cloud Music cookie value (takes priority over `server/.netease_cred`) |
| `AUTH_TOKEN` | auto-generated | Shared auth token (takes priority over `server/.secret`; set it explicitly on ephemeral hosts so the token survives redeploys) |
| `DATA_DIR` | `server/data` | Where playlists, cache, and song memory are stored (mount a volume here on container platforms) |

### Docker

```bash
docker build -t eryu .
docker run -p 9090:9090 \
  -e MUSIC_U=your_cookie_here \
  -e AUTH_TOKEN=pick_a_long_random_string \
  -v eryu-data:/app/data \
  eryu
```

## API

All endpoints require `X-Auth-Token` header (or `?token=` query param).

### Playback
- `GET /music/search?q=keyword` — Search songs
- `GET /music/url?id=songId` — Get audio URL (auto-caches)
- `GET /music/lyric?id=songId` — Get lyrics + translation
- `GET /music/similar?id=songId` — Get similar songs
- `GET /music/roam` — Discover songs from random genres

### Playlists
- `GET /music/playlist` — Default playlist
- `GET /music/playlists` — List all playlists
- `POST /music/playlists/create` — Create playlist
- `POST /music/playlists/add-song` — Add song to playlist
- `POST /music/playlists/remove-song` — Remove song from playlist

### Memory
- `GET /music/memory?id=songId` — Get song notes
- `POST /music/memory` — Save notes, feelings, tags

### Remote
- `POST /music/remote` — Push a song to the player
- `GET /music/remote` — Poll for pushed song

### Listen Together
- `GET /music/room` — Room snapshot: live playback state + who's here (`?room=` for private rooms, default `main`)
- `GET /music/room/poll?since=N` — Long-poll for new events (returns within 25s, or instantly when something happens)
- `POST /music/room/event` — Publish an event: `{user, type, song?, position?, line?}`. Types `track/play/pause/seek` drive the shared player state; `hello/bye/heart/quote` are activity-feed only

## For AI Companions

eryu includes a spectrum analysis feature designed for AI companions to "listen" to music:

```bash
# Analyze a song (requires librosa, numpy, matplotlib)
pip install librosa numpy matplotlib
```

`POST /music/analyze` triggers background analysis. Results include BPM, key, energy curve, and a spectrogram image — everything an AI needs to experience the song alongside you.

## License

MIT
