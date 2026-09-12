# Architecture: <Component / System Name>

**Date:** YYYY-MM-DD  
**Author(s):** <!-- name or @handle -->  
**Status:** Proposed | Active | Deprecated  
**Supersedes:** <!-- link to old doc if this replaces one -->

---

## Overview

<!-- What is this component/system and what is its role in the larger product? -->

## Goals & Non-Goals

**Goals:**
- ...

**Non-Goals:**
- ...

## Design

### High-Level Diagram

<!-- ASCII diagram or Mermaid code block. Even rough diagrams help. -->

```
[Client] → [API Gateway] → [Service A] → [DB]
                         ↘ [Service B] → [Cache]
```

### Key Components

| Component | Responsibility |
|---|---|
| ... | ... |

### Data Flow

<!-- Describe how data moves through the system for the primary use case. -->

### Key Decisions

<!-- Why was this design chosen over alternatives? -->

| Decision | Rationale | Alternatives Considered |
|---|---|---|
| ... | ... | ... |

## Interfaces

<!-- Public APIs, message schemas, contracts between components. -->

## Failure Modes & Mitigations

<!-- What can go wrong? What's the graceful degradation strategy? -->

## Performance Considerations

<!-- Latency targets, throughput, scaling strategy, known bottlenecks. -->

## Security Considerations

<!-- Auth, data sensitivity, attack surface. -->

## Future Work

<!-- Planned improvements or known tech debt. -->
