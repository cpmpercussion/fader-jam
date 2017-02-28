# FaderJam

An experimental iOS app for simple musical interaction.

FaderJam allows users to control a generative musical composition with simple slider controls. Four instruments play in the composition: drums, bass, pad, and lead. Each instrument plays itself in the composition but has interaction parameters governed by four sliders. The user can control the sliders for one instrument at a time, while the other three instruments perform automatically. Full automatic mode is also available!

### Design

FaderJam is designed to be as simple as possible, the app only includes one screen with all faders and controls visible. The synthesis components and generative compositions are realised with Pure Data and `libpd`.

### Research Goals:

- Encouraging everyday musical interaction
- Modelling user performances for the automatic modes
- Exploring generative composition
