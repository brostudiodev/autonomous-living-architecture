# Seven years of hardware: six Arduino Megas, 6 km of cable, and what broke

*A field note from the house this blueprint was built in. Written September 2026.*

The rest of this repository is the architecture. This page is the evidence
underneath it — seven years of running one real house on Home Assistant, what
failed, what I threw away, and the one thing I would do differently if the walls
were open again.

---

## The system

I have run Home Assistant since 2019. It grew the way these things grow: a
sensor here, an integration there. Today it is about 400 entities — the exact
number is hard to pin down — and 40 to 50 of those are lights. Every light in
the house is on it.

The backbone is MySensors. Six Arduino Mega boards sit on a USB hub, and the hub
goes straight into the mini PC that runs Home Assistant. No radio layer, no
gateway box in between.

Cameras are deliberately off that box. Frigate runs on a second mini PC under
Proxmox. Video analysis and the thing that switches my lights do not share a
host, and that is one of the few decisions here I have never had to revisit.

---

## What broke

Three things in seven years, and not one of them was an automation.

1. **The Raspberry Pi.** It did not hold a wired connection. The link kept
   dropping, and a house where every light depends on the host is not the place
   for an intermittent NIC. I moved to a mini PC a few years ago and the problem
   went away completely.

2. **My own Arduino wiring.** It worked, but it was not clean, and the faults it
   caused were the kind you chase all evening and never reproduce. I wrote that
   one up separately: [The Arduino trap that breaks
   projects](https://automationbro.substack.com/p/the-arduino-trap-that-breaks-projects).

3. **Two old Shelly relays**, after a few years in service. Worth saying
   plainly: the newer ones have been fine. That reads like normal hardware wear,
   not a design fault.

The pattern is the point. The failures were physical — a NIC, a solder joint, a
relay — not logical. I expected the software to be the fragile part. It was not.
That is why I now spend more time on the boring layer than on the clever one.

---

## Naming

Entity IDs come from MySensors and I left them as they are:

```
switch.arduino_4_0_6
```

That is device, node ID, child ID, value type. Machine-generated, so it is
stable and never ambiguous, which is what you want when six boards report into
one instance. It is also unreadable on its own, so the readable layer is the
friendly name. Every entity has one:

```
switch.arduino_4_0_6  ->  "Swiatlo Iga sufit 1/2"
```

Two layers, each with one job. The ID is generated, never changes, and I never
type it. The friendly name is the only thing anyone in the house sees. I did not
rename 400 entities and I would not recommend trying.

The friendly names are in Polish, because the house speaks Polish and the
machine layer speaks MySensors. That split is deliberate.

I do automation for a living — manufacturing, twenty years, ITIL and PRINCE2.
The one thing that transfers to a house is the order: **standardize, monitor,
optimize, automate.** In that order. The rule underneath it is that you cannot
automate chaos, and home automation breaks it constantly — we automate first and
standardize never.

---

## What I removed

I test a lot of automations and I keep few. The ones I cut all failed the same
way: they demo beautifully and they do nothing for you on a Tuesday.

- RGB lights that danced to music nobody was listening to.
- A dashboard showing real-time power consumption I never once acted on.
- Voice commands so involved that saying "Hey Google, activate movie night
  scene" took longer than dimming the lights by hand.
- Notifications that pinged constantly with helpful updates, which trained me to
  ignore all of them — including the ones that mattered.

I went through why each of those failed here: [Home automation ideas — a failure
anatomy](https://automationbro.substack.com/p/home-automation-ideas-failure-anatomy).

---

## Two modes, and the mistake of mixing them

I ended up splitting everything into two modes, and this is the part that became
the architecture in this repository.

**Permission-based** — the system senses, analyzes and recommends; you decide
and act. You stay the integration layer. Predictable, stable, and where everyone
should start. That is the
[`automation_phase`](https://github.com/brostudiodev/autonomous-living-architecture/tree/automation_phase)
branch.

**Guardrail-based** — the system perceives, decides, acts within boundaries, and
reports. You move from operator to the person who sets the boundaries. That is
the
[`autonomy_phase`](https://github.com/brostudiodev/autonomous-living-architecture/tree/autonomy_phase)
branch.

The mistake I made for years was mixing the two in the same setup without ever
deciding which one a given automation was. That is what makes a large config
feel unpredictable.

---

## What I would do differently

I pulled about 6 km of UTP CAT5 through this house. I would not do it the same
way again.

- **Less cable inside.** The runs I brought out in the ceiling and at the doors
  have never been used. I built for options I never took.
- **More cable outside.** The garden is what I will want next and there is
  nothing out there. Outdoor runs are cheap while the trenches are open and
  expensive afterwards.
- Past the wiring, I would not change much. It runs well.

---

*Part of [Autonomous Living: The Life Engineering
Blueprint](../README.md). MIT licensed, and deliberately software-agnostic — an
architecture rather than a parts list.*
