# Aperium AI — Interview Cheatsheet

Senior AI/ML Engineer · Initial Screen Prep

---

## 1. Weibull Survival Analysis & Time-to-Event Modeling

**What it is:** Parametric survival model where the hazard rate can increase or decrease over time (shape parameter k). Used to estimate time-until-event (failure, attack, supply depletion) with censored data.

**Core concepts:**
- Hazard function: `h(t) = (k/λ)(t/λ)^(k-1)`
- k < 1 → decreasing hazard; k > 1 → increasing; k = 1 → exponential (constant)
- Survival function: `S(t) = exp(-(t/λ)^k)`
- Censored data: observations where event hasn't occurred yet — Weibull handles this natively via MLE
- Bayesian Weibull: place priors on k and λ, update posteriors as new precursor signals arrive

**JD connection:** "Time-to-event modeling using Weibull survival analysis and Bayesian posterior updating over multi-domain precursor signals"

**Your angle:** Calibrated classification under strict error controls from particle physics maps directly — you managed false discovery rates under sparse signal conditions, same asymmetric cost structure.

---

## 2. Bayesian Posterior Updating Pipelines

**What it is:** Maintain a running belief distribution over a hypothesis; update it as new evidence arrives via Bayes' theorem: `P(H|E) ∝ P(E|H) · P(H)`

**Core concepts:**
- Prior → Likelihood → Posterior → next Prior
- Conjugate priors (Beta-Binomial, Dirichlet-Categorical, Normal-Normal) allow closed-form updates — useful for low-latency hot-tier updates
- MCMC / Variational Inference for non-conjugate models (warm/cold tiers where latency allows)
- Sequential / online Bayesian updating vs. batch retraining
- Tiered latency: hot (streaming, conjugate), warm (near-realtime, approx inference), cold (batch, full MCMC)

**JD connection:** "Bayesian posterior updating pipelines across hot, warm, and cold ingestion tiers with distinct latency targets"

**Your angle:** Bayesian methods and uncertainty propagation from Ph.D. work; real-time multi-sensor fusion pipelines at Machina Labs with tiered processing.

---

## 3. Platt Scaling & Probability Calibration

**What it is:** Post-hoc calibration that maps raw model scores to well-calibrated probabilities.

**Core concepts:**
- **Platt scaling:** Fit a logistic regression `P = 1/(1 + exp(A·f + B))` on held-out scores. Fixes overconfident sigmoid outputs from SVMs/NNs.
- **Isotonic regression:** Non-parametric monotonic calibration; more flexible than Platt but needs more data to avoid overfitting.
- **Expected Calibration Error (ECE):** Key metric — bins predictions by confidence, measures mean |confidence - accuracy| gap.
- **Reliability diagrams:** Visualize calibration; diagonal = perfect calibration.
- Calibration is especially critical when false negatives and false positives carry asymmetric operational costs.
- Temperature scaling: divide logits by T before softmax — single-parameter variant for multiclass.

**JD connection:** "Platt-calibrated with explicit confidence intervals suitable for operational decision-making"

**Your angle:** Calibration under strict error controls is core to your physics work and your Machina Labs anomaly detection thresholding.

---

## 4. DBSCAN Spatiotemporal Clustering

**What it is:** Density-based clustering — no need to specify k clusters; finds arbitrary shapes; robust to noise/outliers.

**Core concepts:**
- Parameters: `ε` (neighborhood radius), `min_samples`
- Core point → ε-neighborhood has ≥ min_samples neighbors
- Border point → within ε of core but fewer own neighbors
- Noise → neither → maps to label `-1`
- **Spatiotemporal extension:** Use a combined distance metric (e.g., haversine for spatial + normalized time delta); or apply ST-DBSCAN with separate spatial and temporal ε thresholds
- Scaling: standard DBSCAN is O(n²); use Ball Tree or KD-Tree for spatial queries; HDBSCAN for varying density

**JD connection:** "DBSCAN spatiotemporal clustering for event aggregation across multi-domain signal streams"

**Your angle:** Listed in your skills; connect to anomaly detection work and particle physics event clustering.

---

## 5. Dynamic Time Warping (DTW)

**What it is:** Elastic similarity measure for time series that aligns sequences by warping the time axis — handles shifts, stretches, and compressions that Euclidean distance misses.

**Core concepts:**
- Dynamic programming: `DTW(i,j) = dist(i,j) + min(DTW(i-1,j), DTW(i,j-1), DTW(i-1,j-1))`
- Warping window constraints (Sakoe-Chiba band) prevent degenerate alignments and speed computation
- FastDTW: O(n) approximation
- Use cases: matching operational activity sequences against historical templates, even when timing differs
- Combine with DBSCAN: cluster time series by DTW distance matrix

**JD connection:** "Dynamic Time Warping (DTW) for pattern matching against historical operational sequences"

**Your angle:** Time-series pattern matching is in your skills; connect to multi-sensor fusion work at Machina Labs.

---

## 6. Data Fusion & Knowledge Graph Stack

### Neo4j (Graph Database)
- Nodes, relationships, properties; Cypher query language
- Entity resolution: MERGE on stable identifiers; confidence-weighted relationship properties
- Temporal versioning: add `valid_from` / `valid_to` properties or use bi-temporal graph modeling
- Use cases: entity attribution, logistics network modeling, pattern-of-life graphs

### Qdrant (Vector Store)
- Vector similarity search with payload filtering
- Collections, points (vector + payload), named vectors for multi-embedding per entity
- Use for semantic retrieval over OSINT text, image embeddings, activity descriptors
- Filtering: combine ANN search with exact metadata filters (e.g., entity_type, date range)

### Apache Iceberg (Columnar Analytical Storage)
- Open table format for data lakes (Parquet files + metadata layer)
- Key features: ACID transactions, schema evolution, time travel (snapshot isolation), partition evolution
- **Time travel:** Query historical state via `AS OF` snapshot — critical for replay and counterfactual analysis
- Works with Spark, Trino, DuckDB, PyArrow
- Compare to Delta Lake / Hudi — Iceberg is engine-agnostic

**JD connection:** "Neo4j (graph), Qdrant (vector store), Apache Iceberg (columnar analytical storage)"; temporal versioning for replay/audit

**Your angle:** Graph Databases, Vector Stores, Columnar/Analytical Storage in your skills. Emphasize Iceberg time-travel → audit/replay requirement.

---

## 7. Entity Resolution & Deduplication

**What it is:** Identifying when records from different sources refer to the same real-world entity.

**Core concepts:**
- Blocking: reduce candidate pairs (LSH, sorted neighborhood, attribute indexing)
- Similarity scoring: string distance (Jaro-Winkler, edit distance), embedding cosine similarity, attribute overlap
- Confidence-weighted merge: don't collapse to single record — maintain provenance + confidence score per attribute
- Deduplication vs. record linkage (within vs. across datasets)
- Active learning loops: surface uncertain matches for human review → feeds back into model

**JD connection:** "Entity resolution, deduplication, and confidence-weighted merge strategies for multi-source entity upserts"

**Your angle:** Multi-sensor fusion at Machina Labs; particle physics track/cluster matching across detector subsystems is structurally the same problem.

---

## 8. NVIDIA Triton Inference Server

**What it is:** High-throughput model serving framework supporting TensorRT, ONNX, PyTorch, TF, Python backends.

**Core concepts:**
- Model repository: directory structure with `config.pbtxt` per model
- Backends: TensorRT (GPU-optimized), ONNX Runtime, PyTorch TorchScript, Python (custom logic)
- Dynamic batching: server aggregates requests within a window to maximize GPU utilization
- Ensemble models: chain models via Triton pipeline; compose preprocessing → model → postprocessing
- Model versions: directory-based versioning; traffic policies for A/B or shadow routing
- gRPC and HTTP/REST endpoints; Prometheus metrics
- Perf Analyzer: benchmarking tool for latency/throughput profiling

**JD connection:** "Deploy and operate NVIDIA Triton Inference Server for all specialist models" + "model versioning, A/B evaluation, zero-downtime promotion"

**Your angle:** Real-time inference serving (Rust/Python) with model versioning and rollback-safe releases at Machina Labs; ONNX in your skills — Triton is the natural extension.

---

## 9. Adversarial Robustness & Data Poisoning

**What it is:** Designing ML systems that remain reliable when adversaries manipulate inputs or training data.

**Core concepts:**
- **Data poisoning:** Attacker injects malicious training samples to shift model behavior (label flipping, backdoor triggers)
- **Adversarial examples:** Small perturbations to inputs that cause misclassification
- **Detection strategies:**
  - Statistical monitoring: drift in input distributions (PSI, KS test, MMD) signals potential poisoning
  - Influence functions: identify training points that disproportionately affect predictions
  - Ensemble disagreement: when specialist models disagree significantly, flag for review
  - Out-of-distribution detection: flag inputs far from training manifold before inference
- **Deception detection:** Multi-source cross-validation — signals that agree suspiciously well across independent sources may indicate coordinated manipulation
- Robust training: data sanitization, certified defenses (randomized smoothing), adversarial training

**JD connection:** "Deception detection algorithms that identify adversarial signal manipulation and data poisoning"; "adversarial robustness testing protocols"

**Your angle:** Adversarial Robustness Testing in your skills; model robustness to dataset shifts is core to your physics interpretability work.

---

## 10. Multi-Model Fusion & Ensemble Architecture

**What it is:** Combining outputs from specialist models into a coherent composite assessment.

**Core concepts:**
- **Preserving independence:** Avoid training ensemble weights on the same data used by base models (leakage → correlated failures)
- **Stacking / meta-learning:** Train a meta-model on held-out base model predictions
- **Calibrated combination:** Combine calibrated probability outputs — log-opinion pool or linear opinion pool
- **Correlated failure modes:** Models trained on same data or sharing features will fail together; ensure specialists use distinct signal sources
- **Tiered alerts:** Map composite scores to operational tiers (e.g., watch → advisory → alert) with explicit thresholds and confidence intervals

**JD connection:** "Multi-model fusion layer correlating specialist outputs into tiered alerts"; "ensemble mechanisms that preserve model independence"

**Your angle:** Parameterized neural networks paper (composing specialists across regimes); multi-sensor fusion at Machina Labs.

---

## 11. MCP (Model Context Protocol)

**What it is:** Anthropic's open standard for connecting LLM agents to external tools, data sources, and services via a structured server/client protocol.

**Core concepts:**
- MCP servers expose: **Tools** (callable functions), **Resources** (data/files), **Prompts** (templates)
- Client (LLM host) discovers and calls tools via JSON-RPC over stdio or HTTP/SSE
- Tool definitions include name, description, and JSON Schema for parameters
- Stateless vs. stateful servers; session management for stateful workflows
- Use case in this JD: orchestration layer connecting specialist ML models, knowledge graph queries, alert generation — agents call tools to query Neo4j, Qdrant, trigger Triton inference

**JD connection:** "Familiarity with MCP (Model Context Protocol) server architecture or equivalent tool-layer orchestration patterns"

**Your angle:** MCP Server Architecture is directly in your skills section. Discuss as the orchestration glue between the inference core and analyst-facing interfaces.

---

## 12. Composite Threat Scoring & Confidence Intervals

**What it is:** Aggregating multi-signal specialist outputs into a single actionable score with calibrated uncertainty bounds.

**Core concepts:**
- Platt-calibrate each specialist model output first
- Weighted combination based on source reliability (inverse variance weighting for independent signals)
- Bootstrap or Monte Carlo methods to propagate uncertainty into composite CI
- Explicit confidence intervals — not just a point estimate — so analysts know how much to trust each alert
- Track ECE and prediction lead time as operational KPIs; false alert rate and intervention frequency

**JD connection:** "Composite threat scoring — multi-signal index construction with Platt-calibrated confidence intervals"

**Your angle:** Calibration (Platt/Isotonic) and Uncertainty Quantification are lead items in your skills; calibrated anomaly thresholds at Machina Labs.

---

## 13. pgvector & PostgreSQL

**What it is:** PostgreSQL extension adding vector similarity search — combines structured relational queries with approximate nearest-neighbor search.

**Core concepts:**
- `CREATE EXTENSION vector;` — adds `vector` type
- Index types: IVFFlat (fast approx, requires training), HNSW (better recall, no training)
- Query: `SELECT ... ORDER BY embedding <-> query_vector LIMIT k` (L2); `<=>` for cosine
- Combine vector search with standard SQL filters in a single query
- pgvector vs. Qdrant: pgvector is simpler/co-located with relational data; Qdrant scales better for pure vector workloads

**JD connection:** "PostgreSQL/pgvector ... experience"

**Your angle:** PostgreSQL is in your skills; frame pgvector as the relational complement to Qdrant for hybrid queries.

---

## 14. Behavioral Attribution & Pattern-of-Life Modeling

**What it is:** Building behavioral fingerprints for entities from activity patterns to enable identification and attribution.

**Core concepts:**
- Temporal rhythm features: activity frequency distributions, inter-event intervals, time-of-day/week patterns
- Spatial patterns: home location inference, movement corridors, venue associations
- Anomaly from baseline: Z-score or statistical process control over rolling behavioral baseline
- Entity linking across aliases/platforms via behavioral similarity (not just identifier matching)
- Long-horizon baselines: rolling window statistics with exponential decay to weight recency

**JD connection:** "Behavioral attribution — fingerprinting and pattern-of-life modeling"; "Long-horizon behavioral baseline construction and anomaly detection"

**Your angle:** Real-time anomaly detection over streaming multi-sensor data at Machina Labs; long-horizon baseline construction is structurally identical to your process monitoring work.

---

## 15. Key Operational / Culture Talking Points

**Asymmetric cost of errors:**
- False negative (miss a real threat) >> False positive cost in this domain
- Frame all threshold and calibration decisions through this lens
- Connect to your Machina Labs work: missed defect cost >> false alarm cost drove threshold design

**Compliance & export control:**
- Northrop Grumman background + former Secret clearance (inactive)
- Framing: compliance is an engineering constraint you design for, not overhead

**Production ≠ notebooks:**
- Emphasize shipped systems: real-time inference serving, rollback-safe releases, human-in-the-loop feedback, CI/CD
- Machina Labs: edge + cloud deployment on physical manufacturing systems = real operational stakes

**Physics → intelligence platform transfer:**
- Multi-tier event selection (L1/L2/HLT) = hot/warm/cold ingestion tiers
- Rare-event search in dominant background = low base-rate threat detection
- Multi-subsystem detector fusion = multi-domain signal fusion
- Strict false discovery rate control = calibrated confidence intervals for decisions

---

## Quick Reference: Tech Stack Gaps to Review

| Topic | Familiarity | Prep Priority |
|---|---|---|
| Weibull survival analysis | Moderate (stats background) | High — likely to be asked directly |
| Apache Iceberg time travel | Lower | High — specific + niche |
| NVIDIA Triton Inference Server | Listed ONNX/serving | Medium — review config.pbtxt, dynamic batching |
| DTW | Moderate | Medium — know the DP formulation |
| Neo4j Cypher queries | Listed graph DBs | Medium — review basic MERGE/MATCH patterns |
| Qdrant API | Listed vector stores | Medium — review collection/point operations |
| pgvector index types | Listed PostgreSQL | Lower — brief review sufficient |
| CesiumJS | Not listed | Low — preferred, not required |
