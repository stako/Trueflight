# Trueflight

**A sleek shot timer for Hunters that just works.**

Trueflight is a lightweight, reliable shot timer designed specifically for Hunters in WoW Classic. It tracks **Auto Shot**, **Multi-Shot**, and **Aimed Shot**, giving you clear visual feedback for perfect timing — without clutter or fuss.

## 🎯 Features

**Auto Shot Bar**
Displays both the cast time and cooldown (swing timer) of Auto Shot.

**Multi-Shot Clip Indicator**
A shaded area on the Auto Shot bar that warns you when using Multi-Shot would delay your next Auto Shot.

**Built-in Retry Timer Logic**
Accounts for Blizzard’s hidden Auto Shot “retry timer” for more accurate and reliable Auto Shot timing.

**Cast Bar for Multi-Shot & Aimed Shot**
Shows the cast time of Multi-Shot and Aimed Shot, which do not appear on the default WoW Classic cast bar.

**Blizzard-style visuals**
Clean, minimalistic appearance that blends seamlessly with the default UI.

**Zero setup required**
Install and go — no configuration needed out of the box.

**Lightweight and efficient**
Built for performance with no unnecessary bloat.

## ⚙️ Slash Commands

*   `/trueflight` or `/tf` — Open the configuration menu
*   `/trueflight test` or `/tf test` — Toggle test mode on/off
*   `/trueflight hide` or `/tf hide` — Turn off test mode

## ❓ FAQ

**Can I move or scale the bar?**
Yes. Positioning and scaling can be adjusted via the `/trueflight` options GUI. While test mode is enabled, positioning can also be adjusted by clicking & dragging.

**Does it work for other classes?**
No. Trueflight is tailored specifically for Hunters and their unique shot mechanics.

**Why does the Auto Shot bar stutter or reset during the cooldown period?**
This usually happens if you're using `/cast !Auto Shot` in your macros — especially in instant cast abilities like Arcane Shot or Chimera Shot.

When you attempt to cast Auto Shot while it's still on cooldown (during its swing timer), Blizzard's “retry timer” kicks in, delaying your next Auto Shot by up to **0.5 seconds**. This causes the bar to stutter or reset as it reflects the updated timing.

***Recommendation:***
Remove `/cast !Auto Shot` from your non-Auto Shot macros. Including Auto Shot like this is not only unnecessary in Classic — it can actually reduce your DPS.

See [this post by Sixx on the Blizzard forums](https://us.forums.blizzard.com/en/wow/t/classic-hunter-the-retry-timer/542470) (point #4) for more info on how the retry timer works.

## 🛠️ Contributing / Feedback

Have a suggestion or found a bug? Open an issue or submit a pull request on [GitHub](https://github.com/stako/Trueflight).
