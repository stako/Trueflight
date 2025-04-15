# Trueflight

**A sleek shot timer for Hunters that just works.**

Trueflight is a lightweight, reliable shot timer designed specifically for Hunters in WoW Classic. It tracks **Auto Shot**, **Multi-Shot**, and **Aimed Shot**, giving you clear visual feedback for perfect timing — without clutter or fuss.

## 🎯 Features

- Clean, minimalistic cast bar styled to match the default UI
- Zero setup required — install and go
- Lightweight and efficient

## ⚙️ Slash Commands

- "/trueflight" (or just "/tf") will open the configuration menu
- "/trueflight test" (or just "/tf test") will toggle test mode on/off
- "/trueflight hide" (or just "/tf hide") will turn test mode **off**

## ❓ FAQ

**Can I move or scale the bar?**  
Yes. Positioning and scaling can be adjusted via the /trueflight options GUI. While test mode is enabled, positioning can also be adjusted by clicking & dragging.

**Does it work for other classes?**  
No. Trueflight is tailored specifically for Hunters and their unique shot mechanics.

**Why does the auto shot bar stutter during the cooldown period?**  
TLDR: Remove `/cast !Auto Shot` from your non-Auto Shot macros. It's bad for your DPS.


This happens if you try to cast Auto Shot while its swing timer is running (i.e. Auto Shot is on cooldown). Typically this would be from an instant shot macro (Arcane/Chimera/Explosive Shot) that has Auto Shot included in it. Using such a macro will trigger Auto Shot's retry timer, which will delay your next Auto Shot by up to 0.5 seconds. See point #4 from Sixx's article on the Blizzard forums [here](https://us.forums.blizzard.com/en/wow/t/classic-hunter-the-retry-timer/542470).

## 🛠️ Contributing / Feedback

Have a suggestion or found a bug? Open an issue or submit a pull request on [GitHub](https://github.com/stako/Trueflight).
