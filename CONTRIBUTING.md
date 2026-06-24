# Contributing Guide

Thank you for wanting to contribute to this project!

## Guiding Principles

- **Simplicity**: Minimal configuration to get started quickly
- **Reproducibility**: Same environment on all machines
- **Lightweight**: No unnecessary services or infrastructure
- **Security**: Non-root user, no hardcoded credentials

## Git Workflow

**Important**: NEVER push directly to `main`. All changes must go through a **feature branch** and a **Pull Request**.

### 1. Create a feature branch

```bash
git checkout -b feat/my-feature
```

Branch naming:
- `feat/add-mcp-servers` - new features
- `fix/docker-build` - bug fixes
- `docs/update-readme` - documentation
- `chore/update-dependencies` - maintenance

### 2. Commit with conventional messages

```bash
git add .
git commit -m "feat: add postgres service with healthcheck"
```

Format: `feat:`, `fix:`, `docs:`, `chore:`

### 3. Push and create a PR

```bash
git push origin feature/my-feature
```

Then create a PR on GitHub from your branch to `main`.

## PR Checklist

- [ ] Code tested locally with `docker-compose up`
- [ ] Clear and conventional commit messages
- [ ] README updated if necessary
- [ ] Environment variables documented
- [ ] No secrets or credentials in the code
- [ ] No workspace files committed (`.gitignore` respected)

## Service Modification Guidelines

- **Dockerfile**: Keep only essential installations. Always use specific versions. Clean caches after apt-get/npm. Maintain non-root user.
- **docker-compose.yml**: Document each environment variable. Keep dependencies explicit (`depends_on`).
- **Configuration files**: YAML with 2-space indentation. Comment optional configurations.

## Reporting a Bug

Create an issue with:
- Clear description of the bug
- Steps to reproduce
- Expected vs. actual result
- Output of `docker-compose ps`

## Suggesting an Improvement

Create a discussion or issue with:
- Description of the improvement
- Use case / context
- Proposed solution (if applicable)
