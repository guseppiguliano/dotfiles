brew install duti gnu-tar git wget
ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
ln -s /Applications/TrueCrypt.app/Contents/MacOS/TrueCrypt /usr/local/bin/truecrypt
ln -s /Applications/Gimp.app/Contents/MacOS/gimp-2.8 /usr/local/bin/gimp
ln -s /Applications/VLC.app/Contents/MacOS/VLC /usr/local/bin/vlc
sudo xattr -d -r com.apple.quarantine /Applications/
grep -nr paginator .
find . -name "*.css" | xargs -l10 grep ".ir"

# press ⌘⇧. (Cmd+Shift+.) to show dotfiles in Open/Save dialogs

# path of PID
ps xuwww -p <PID>

# convert tiff files to png
for f in *.tiff; do sips -s format png "$f" --out "${f%.*}.png"; done


# brew multi-user setup
sudo dseditgroup -o create brew
sudo dseditgroup -o edit -a stefansundin -t user brew
sudo dseditgroup -o edit -a home -t user brew
sudo chgrp -R brew /usr/local /Library/Caches/Homebrew
sudo chmod -R g+w /usr/local /Library/Caches/Homebrew
sudo chmod -R +a "brew allow list,search,add_file,add_subdirectory,delete_child,readattr,writeattr,readextattr,writeextattr,readsecurity,file_inherit,directory_inherit" /usr/local /Library/Caches/Homebrew

# if 'brew doctor' complains that locale files aren't writable
sudo chown -R stefansundin /usr/local /Library/Caches/Homebrew
sudo chmod -R g+w /usr/local /Library/Caches/Homebrew
cp /usr/local/Cellar/mongodb/2.6.0_1/homebrew.mxcl.mongodb.plist ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist

# install brew cask (precompiled binaries)
brew tap phinze/cask
brew install brew-cask

# keyboard key-repeat
defaults write -g ApplePressAndHoldEnabled -bool false

# fix Home/End on full-size keyboards
mkdir ~/Library/KeyBindings/
vim ~/Library/KeyBindings/DefaultKeyBinding.dict
{
"\UF729"  = "moveToBeginningOfLine:";   /* Home */
"\UF72B"  = "moveToEndOfLine:";         /* End  */
"$\UF729" = "moveToBeginningOfLineAndModifySelection:"; /* Shift + Home */
"$\UF72B" = "moveToEndOfLineAndModifySelection:";       /* Shift + End  */
}
# NSUserKeyEquivalents
# @    Command (Apple)  CMD
# ~    Option           OPT
# $    Shift            SHIFT
# ^    Control          CTRL


# Finder.app
# backspace to go up
defaults write com.apple.finder NSUserKeyEquivalents -dict-add "Back" "\U232B"
killall Finder
# preferences (⌘,)
#  General → New Finder windows show: stefansundin
#  Advanced → [x] Show all filename extensions
# show dotfiles
defaults write com.apple.finder AppleShowAllFiles -bool true
# don't warn when renaming file extensions
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# don't create .DS_Store on network drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# disable “VLC.app is an application downloaded from the Internet. Are you sure you want to open it?”
sudo defaults delete com.apple.LaunchServices LSQuarantine
defaults write com.apple.LaunchServices LSQuarantine -bool false
sudo xattr -d -r com.apple.quarantine /Applications
# sort by Kind by default
#  show view options (⌘J) → Sort By: Kind. [Use as Defaults]
#  remove .DS_Store files to remove custom directory settings
# disable fullscreen swoosh
defaults write -g NSWindowResizeTime -float 0.01
defaults read -g NSWindowResizeTime
# QuickLook plugins
brew cask install qlstephen qlmarkdown qlprettypatch qlimagesize qlcolorcode quicknfo betterzipql suspicious-package quicklook-json quicklook-csv
qlmanage -r
https://github.com/whomwah/qlstephen
# enable text selection in QuickLook
defaults write com.apple.finder QLEnableTextSelection -bool true
killall Finder
# sort Folders on top
cd /System/Library/CoreServices/Finder.app/Contents/Resources/English.lproj/
sudo plutil -convert xml1 InfoPlist.strings
sudo vim InfoPlist.strings
 <key>Folder</key>
 <string> Folder</string>
sudo plutil -convert binary1 InfoPlist.strings
# make delete key to move files to trash
defaults write com.apple.finder NSUserKeyEquivalents -dict-add 'Move to Trash' '\U007F'
defaults read com.apple.finder NSUserKeyEquivalents
# WARNING: DELETE KEY WILL NOW DELETE FILE WHEN ATTEMPTING TO RENAME THEM!! USE BACKSPACE!

# Calendar.app: ignore alerts from specific calendars
# Right-click calendar → Get Info → [x] Ignore alerts

# disable iTunes automatically copying files to iTunes directory
# iTunes → Preferences → Advanced → [ ] Copy files to iTunes Music folder when adding to library

# system shortcuts
# Mission Control: F3
# Application windows: ⇧F3
# Tip: Drag a window when pressing ^← and ^→ to move that window too.

# remove dashboard
# System Preferences → Mission Control
# [ ] Show Dashboard as a Space
# Show Dashboard: [ - ]

# enable SSH server
# System Settings → Sharing → [x] Remote Login

# share files between Mac and PC
# System Settings → Network → Advanced → WINS
# Workgroup: WORKGROUP
# System Settings → Sharing → [x] File Sharing → Options
# [x] Share files and folders using SMB (Windows)

# mute startup chime (does not work every time)
sudo nvram SystemAudioVolume=%80
vim /etc/rc.common
 # mute startup chime
 nvram SystemAudioVolume=%80
# re-enable
sudo nvram -d SystemAudioVolume
# print setting
nvram -p | grep SystemAudioVolume

# show advanced printer settings
cupsctl WebInterface=yes
# http://localhost:631/

# hidden startup items
# (/System)/Library/Launch{Agents,Daemons}
# /Library/StartupItems


# iTerm 2 key bindings
# add Profile shortcuts since they have highest priority

# Key Combination | Action
# --------------- | ------
# ⌥←              | Send ESC + b
# ⌥→              | Send ESC + f
# ⌥←Delete        | Send Hex Code: 0x17
# ⌘←Delete        | Send Hex Code: 0x15
# Del→            | Send Hex Code: 0x04

# make Alt+Backspace properly stop at delimiters
# iTerm preferences → Profiles → Keys → Left option (⌥) key acts as: (x) +Esc

# use read to get keyboard input sequences. Press C-v to bypass terminal parsing (verbatim mode).
# https://code.google.com/p/iterm2/wiki/Keybindings#Escape_sequence_exploration


# additional apps
# MagicPrefs to make mouse better
# MacUtil: https://russellsayshi.com/MacUtil/home
# USB Overdrive
#  Wheel up/down → Speed: [5 lines]
# iStat Menus
# CheatSheet
# Android:
#  File Transfer: http://www.android.com/filetransfer/
#  HoRNDIS (USB Tethering): http://joshuawise.com/horndis
# prevent local .DS_Store files: http://asepsis.binaryage.com/#installation


# global SteamApps
mv Library/Application\ Support/Steam/SteamApps/ /Library/
rm -r Library/Application\ Support/Steam/SteamApps/
ln -s /Library/SteamApps Library/Application\ Support/Steam/

# wireshark permissions
sudo dseditgroup -o edit -a stefansundin -t user access_bpf
sudo dseditgroup -o edit -a home -t user access_bpf


# file extension associations
# http://duti.org/
brew install duti
# get current associations
open ~/Library/Preferences/com.apple.LaunchServices.plist
# only LSHandlerContentType can be used
for type in public.mpeg-4 public.avi public.mp3 public.mp2 com.apple.quicktime-movie com.microsoft.waveform-audio; do duti -s org.videolan.vlc $type all; done
for type in conf ini public.plain-text public.php-script public.shell-script public.ruby-script public.xml com.apple.log public.comma-separated-values-text com.netscape.javascript-source net.daringfireball.markdown com.barebones.bbedit.ini-configuration; do duti -s com.sublimetext.3 $type all; done
duti -s com.adobe.reader com.adobe.pdf all


# uninstall heroku toolbelt
gem uninstall heroku -a -x --force
brew uninstall heroku
sudo rm -rf /usr/local/heroku /usr/bin/heroku
# remove heroku from PATH in .profile, .bashrc or .bash_profile
