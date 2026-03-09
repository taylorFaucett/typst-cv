# HEP Statistical Methods — Refresher & Aperium Bridge

Particle physics statistics refresher connecting Ph.D. work to Aperium's inference pipeline requirements.

---

## 1. The Core Problem (Signal in Background)

In HEP, your dataset is dominated by **background** (known Standard Model processes). You're searching for a **signal** (new physics) hiding in a specific region or in the tails of a distribution. The signal rate is unknown — you're either setting an upper limit on it or claiming evidence for its existence.

This is structurally identical to Aperium's problem: a stream of events dominated by normal activity, searching for rare coordinated operational signals with unknown prevalence.

---

## 2. The Likelihood Framework

Everything in HEP statistics is built on the **profile likelihood ratio**:

```
λ(μ) = L(μ, θ̂̂) / L(μ̂, θ̂)
```

- `μ` = signal strength parameter (0 = background-only, 1 = predicted signal, free for BSM)
- `θ` = nuisance parameters (systematic uncertainties: detector resolution, luminosity, background normalization)
- `θ̂̂` = nuisance values that maximize L for a *fixed* μ — this is **profiling**
- `μ̂, θ̂` = values at the global maximum of L

The test statistic `q = -2 ln λ(μ)` is approximately chi-squared distributed under Wilks' theorem, which lets you compute p-values analytically.

**Profiling over nuisances is conceptually close to Bayesian marginalization** — the difference is MAP vs. full integral. In practice the results are often similar.

---

## 3. Signal/Background Template Fits

The standard binned analysis likelihood:

```
L(μ, θ) = ∏_bins Poisson(n_obs | μ · s(θ) + b(θ)) · ∏_syst Gauss(θ_i | 0, 1)
```

- Signal (`s`) and background (`b`) yields are functions of nuisance parameters
- Systematic uncertainties enter as constrained nuisances — Gaussian or log-normal priors
- **HistFactory** (ATLAS/CMS standard) implements this; `pyhf` is the modern Python port

The Gaussian constraint terms on nuisances are effectively priors. This makes the template fit **implicitly Bayesian** — you're doing MAP inference over nuisances while profiling over μ.

---

## 4. Hypothesis Testing & the CLs Method

Two competing hypotheses:
- **H₀** (background-only): `μ = 0`
- **H₁** (signal + background): `μ = 1` or best-fit `μ̂`

**p-value:** Probability of observing data this extreme or more under H₀. In HEP, 5σ (p ≈ 2.9×10⁻⁷) is the discovery threshold. 3σ is "evidence."

**CLs method** (standard for exclusion limits):
```
CLs = CLs+b / CLb
```
- CLs+b: p-value under signal+background hypothesis
- CLb: p-value under background-only hypothesis
- The ratio prevents excluding signal models the experiment has no sensitivity to
- CLs < 0.05 → exclude at 95% CL

**Expected limits:** Generate pseudo-experiments under H₀ → median expected limit + ±1σ, ±2σ bands ("Brazil band"). The observed limit vs. expected bands tells you if your data is consistent with background-only.

---

## 5. Bayesian Posterior on Signal Strength

The explicitly Bayesian formulation:

```
P(μ | data) ∝ ∫ L(data | μ, θ) · π(μ) · π(θ) dθ
```

- Integrate (marginalize) over nuisances θ rather than profiling
- Common priors: flat or log-flat for μ ≥ 0; Gaussian for systematic nuisances
- 95% upper limit: value μ_lim where ∫₀^μ_lim P(μ|data) dμ = 0.95
- Natural interpretation ("probability signal strength is below X") but prior-dependent

**In practice:** ATLAS/CMS use frequentist CLs for official limits and Bayesian methods for cross-checks and nuisance marginalization. Both are in your toolkit.

---

## 6. Nuisance Parameters — Uncertainty Propagation

This is the most important concept to carry forward:

- **Systematic uncertainties** (detector resolution, background normalization, energy scale) enter as nuisance parameters
- You don't fix them — you profile or marginalize over them
- This propagates *all* sources of uncertainty into the final result automatically
- The posterior/profile of a nuisance shows how much the data constrains it beyond the prior ("pulled" nuisances indicate model misfit)

**Key insight:** The final confidence interval on μ accounts for all systematic uncertainties. This is what makes HEP results trustworthy — no uncertainty is silently dropped.

**Direct Aperium analog:** Uncertainty in sensor reliability, source credibility, or model parameters should propagate through to confidence intervals on threat scores. The JD's "Platt-calibrated with explicit confidence intervals" is the same requirement — no hiding uncertainty inside a point estimate.

---

## 7. Anomaly Detection & Model-Independent Searches

Directly relevant to the semi-visible jets work:

**Resonance / BUMP HUNT:**
- Fit a smooth parametric background model to sidebands
- Interpolate under the signal region; compare observed counts to extrapolated background
- Poisson likelihood on the excess; no MC signal model required
- Sensitive to any localized excess regardless of physical origin

**Autoencoder / density estimation searches:**
- Train on background-only data
- High reconstruction error or low density = anomaly
- Calibrate threshold to a target false positive rate — operationally identical to setting an alert threshold

**CWoLa (Classification Without Labels):**
- Train classifier on signal-region (mixed) vs. sideband (background-only) data
- Signal enrichment in the signal region creates a learnable difference
- No labeled signal MC needed; the classifier discovers the anomaly

**Look-elsewhere effect:**
- A 3σ local excess might be only 1σ globally after accounting for all tested regions
- Corrected via trial factors or by scanning with pseudo-experiments under H₀
- Critical discipline: always report global significance, not just the most exciting local result

---

## 8. MCMC in HEP

Used when the likelihood is too high-dimensional to profile analytically:

- **Metropolis-Hastings** or **HMC (NUTS)** to sample `P(μ, θ | data)`
- Marginalize over θ samples to get the signal strength posterior
- Common in: global electroweak fits, BSM parameter scans (SUSY), global PDF fits
- Tools: Stan, PyMC, custom implementations
- Output is a set of samples — compute any posterior summary (mean, median, HDI) from them

---

## 9. Multi-Tier Trigger System (L1/L2/HLT)

Your direct operational experience with tiered inference under latency constraints:

| Trigger Level | Latency | Rate In | Rate Out | Method |
|---|---|---|---|---|
| L1 (hardware) | ~4 μs | ~40 MHz | ~100 kHz | Simple threshold cuts on coarse quantities |
| L2 (software) | ~40 ms | ~100 kHz | ~1 kHz | Fast regional reconstruction, approximate |
| HLT (software) | ~400 ms | ~1 kHz | ~1 kHz | Full offline-quality reconstruction |

Each tier makes a fast, lossy decision to pass events downstream for more expensive processing. False negatives at L1 are unrecoverable — the asymmetric cost of missing a signal was a hard constraint.

---

## 10. Frequentist vs. Bayesian in HEP — Quick Reference

| Approach | Used for | Key tool |
|---|---|---|
| Profile likelihood (frequentist) | Discovery significance, limits | pyhf, RooStats |
| CLs | Exclusion limits | ATLAS/CMS standard |
| Bayesian posterior | Cross-checks, nuisance marginalization | PyMC, custom MCMC |
| Gaussian process | Smooth background modeling in sidebands | GPyTorch, custom |
| Toy MC / pseudo-experiments | Expected limits, p-value validation | RooStats, custom |

---

## 11. Connecting HEP to Aperium's Pipeline

| HEP concept | Aperium analog |
|---|---|
| Signal strength `μ` with CI | Threat score with Platt-calibrated confidence interval |
| Nuisance parameters (profiled/marginalized) | Sensor reliability and source uncertainty propagated through to output |
| CLs threshold (false exclusion protection) | Alert threshold design balancing false negative vs. false positive cost |
| Background-only hypothesis H₀ | Behavioral baseline; deviation from it = anomaly |
| Look-elsewhere effect | Multiple entity types and signal streams monitored simultaneously → trial factor analog |
| Template fit across bins | Multi-signal index construction across specialist model outputs |
| BUMP HUNT / sideband fit | Anomaly detection over a learned baseline distribution |
| Bayesian posterior update on new events | Sequential Bayesian update as new precursor signals arrive (hot-tier conjugate updates) |
| L1/L2/HLT trigger tiers | Hot/warm/cold ingestion tiers with distinct latency targets |
| Rare event search in dominant background | Low base-rate threat detection in high-volume activity stream |
| Multi-subsystem detector fusion (calorimeter + tracker + muon) | Multi-domain signal fusion (satellite + logistics + OSINT + sensors) |
| Strict false discovery rate control | Calibrated confidence intervals for operational decisions |
| Parameterized neural networks (varying signal hypothesis) | Specialist models composed across regimes in multi-model fusion layer |

---

## 12. The Through-Line for the Interview

**Uncertainty quantification is a first-class output, not an afterthought.**

Every HEP result ships with a confidence interval. The interval accounts for statistical uncertainty (data counts) and systematic uncertainty (nuisances) through profiling or marginalization. A result without an uncertainty is not publishable — period.

This is exactly the "no hiding behind point estimates" competency Aperium is testing for. The JD phrase "Platt-calibrated with explicit confidence intervals suitable for operational decision-making" is the same requirement expressed in ML terms. The physics instinct is the right one: always know how confident you are and be explicit about it.

The other through-line is **asymmetric cost of errors.** In HEP you need 5σ for discovery — the cost of a false discovery (claiming new physics that isn't real) is enormous for the field. At Aperium the cost is reversed: false negatives (missing a real threat) carry the asymmetric risk. The discipline of thinking carefully about which error is worse, and designing your threshold and calibration accordingly, is identical — only the direction flips.
