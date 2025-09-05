# Build Workflow Improvements

This document outlines the improvements made to the Docker build workflow in this repository.

## Summary of Changes

### Updated Action Versions
- `docker/build-push-action`: v5 → v6.18.0
- `docker/login-action`: v3 → v3.5.0  
- `docker/setup-qemu-action`: v3 → v3.6.0
- `docker/setup-buildx-action`: v3 → v3.11.1

### Enhanced Caching Strategy
- **Scoped Cache Keys**: Each image now uses targeted cache keys (`buildx-{image}-{tag}`) for better cache isolation
- **Multi-tier Cache Lookup**: Images first check their specific cache, then fall back to general image cache
- **Improved Cache Sharing**: Related images can benefit from shared cache layers

### Build Reliability Improvements
- **Timeouts**: Added 45-minute timeout per build step to prevent hanging builds  
- **Build Progress**: Added `BUILDKIT_PROGRESS=plain` for better build visibility
- **Error Handling**: Explicit `continue-on-error: false` to fail fast on issues

### Enhanced Workflow Features
- **Manual Triggering**: Added `workflow_dispatch` trigger for manual builds
- **Enhanced Permissions**: Added `attestations: write` and `id-token: write` for security features
- **Disabled Provenance/SBOM**: Reduced build overhead by disabling unnecessary features

### Workflow Structure Preserved
- **Dependency Detection**: Maintained existing dependency parsing and build-contexts
- **Build Order**: Preserved sequential build order to respect interdependencies
- **Image Variants**: Continued support for both `root` and `latest` (nonroot) variants

## Benefits

1. **Faster Builds**: Better cache hit rates reduce build times
2. **More Reliable**: Improved error handling and timeouts prevent stuck builds
3. **Better Observability**: Enhanced build progress and logging
4. **Modern Actions**: Latest action versions with bug fixes and performance improvements
5. **Maintainable**: Preserved existing generation logic in `test.sh`

## Cache Strategy Details

### Cache Scoping
Each build now uses a two-tier cache lookup:
```yaml
cache-from: |
  type=gha,scope=buildx-{image}-{tag}    # Specific cache
  type=gha,scope=buildx-{image}          # Fallback cache
cache-to: type=gha,mode=max,scope=buildx-{image}-{tag}
```

This allows:
- Fast rebuilds when only specific image changes
- Cache sharing between root/latest variants of same image  
- Reduced cache conflicts between different images

### Environment Variables
Added build optimization environment variables:
- `SOURCE_DATE_EPOCH: 0` - Reproducible builds
- `BUILDKIT_PROGRESS: plain` - Better build output
- `DOCKER_BUILDKIT: 1` - Ensure BuildKit is used

## Future Considerations

Potential additional improvements that weren't implemented to maintain minimal changes:
- **Parallel Builds**: Could build independent images in parallel jobs
- **Conditional Builds**: Skip builds when Dockerfiles haven't changed
- **Matrix Builds**: Use build matrix for better parallelization
- **Security Scanning**: Integrate security scanning into the workflow
- **Build Summaries**: Add job summaries with build metrics

The current improvements focus on reliability, caching efficiency, and using latest stable action versions while preserving all existing functionality.