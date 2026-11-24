# Unofficial MoonlightWeb for iPhone

A native WKWebView wrapper for an existing MoonlightWeb server. It does not bundle or replace the PC server or claim affiliation with upstream. It loads the actual upstream streaming page from the URL you enter. The app saves the host address and uses WebKit's normal persistent website data store. Fullscreen mode can be exited using the floating three-dot button. Touch controls, audio, gamepad, pairing, and video depend on the upstream client and WebKit compatibility; these have not been tested on an iPhone. HTTPS certificates are not bypassed. HTTP may have WebRTC secure-context limitations, so use the upstream HTTPS link where possible.

## GitHub Actions (no Mac required)
1. Create a repository on GitHub (private is fine). Initialize it with a README, using `main` as its default branch.
2. Upload MoonlightWeb.m, Info.plist, build.sh, and all four AppIcon PNG files from this package into the repository root. You may also upload this README.
3. Use Add file > Create new file. Enter `.github/workflows/build.yml` as the filename and paste the contents of `workflow-copy.yml` from this package. Commit the file. If you can upload the entire folder including hidden files, you can instead upload the original `.github/workflows/build.yml` directly.
4. Open Actions > Build iPhone IPA. Select the latest run, or use Run workflow if needed. On success download the MoonlightWeb-IPA artifact ZIP.
5. Extract the artifact ZIP to obtain MoonlightWeb.ipa. Import it into your sideloader and sign it using your existing certificate. Enable Developer Mode if the sideloader requires it. The ad-hoc signature in the build is not an installable Apple developer signature.

## Mac build
Install Xcode and select its command-line tools, then run `bash build.sh` in this folder. The resulting IPA is `output/MoonlightWeb.ipa`.

## Use
Install the real PC server from https://moonlightweb.top/ or https://github.com/linckosz/moonlight-web/releases . Launch it, copy its streaming URL (not the marketing website), open the iPhone app, tap Connect, paste the URL, and pair with the PIN if requested. Keep the PC running. The app is not a cloud streaming service.

## Build status
The Objective-C wrapper was syntax-checked against minimal Objective-C interface declarations in an iOS arm64 compile in the authoring environment. A native executable could not be linked here because the available linker lacks Apple platform support. The real-SDK build workflow and physical-device operation are untested. This archive is source, not an IPA.
