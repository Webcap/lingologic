# Flutter Network Setup for Better Auth

## The Problem

Flutter app on Android emulator can't connect to `localhost:3000` because:
- Android emulator treats `localhost` as the emulator itself, not your host machine
- The backend server is running on your host machine, not in the emulator

## Solution

### Option 1: Use Android Emulator's Special IP (Automatic)

The code has been updated to automatically use `10.0.2.2` for Android emulators, which maps to your host machine's `localhost`.

**No configuration needed** - it should work automatically now!

### Option 2: Use Network IP Address

If `10.0.2.2` doesn't work, use your computer's network IP:

1. **Find your network IP:**
   - Windows: Run `ipconfig` and look for "IPv4 Address" (e.g., `192.168.1.38`)
   - The Next.js server shows it: `Network: http://192.168.1.38:3000`

2. **Update `.env` file in Flutter project:**
   ```env
   BETTER_AUTH_URL=http://192.168.1.38:3000
   ```

3. **Restart Flutter app**

### Option 3: Use Physical Device

If testing on a physical device:
1. Make sure your phone and computer are on the same WiFi network
2. Use the network IP (e.g., `http://192.168.1.38:3000`)
3. Update `.env` or use the network IP directly

## Current Configuration

The `BetterAuthConfig` now automatically:
- ✅ Uses `10.0.2.2:3000` for Android emulators
- ✅ Uses `localhost:3000` for iOS simulators
- ✅ Uses `BETTER_AUTH_URL` from `.env` if set
- ✅ Falls back to production URL in release mode

## Testing

After updating, restart the Flutter app and the connection errors should be gone!

## Troubleshooting

**Still getting connection refused?**
1. Make sure backend server is running: `npm run dev` in `lingologic-api`
2. Check the server shows: `Network: http://192.168.1.38:3000`
3. Try using the network IP in `.env`: `BETTER_AUTH_URL=http://192.168.1.38:3000`
4. Make sure firewall allows connections on port 3000




