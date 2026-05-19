# Copilot Instructions

## Project Standards
- Use Python 3.11+ with type hints
- All functions need docstrings
- Follow PEP 8

## Environment Verification
When debugging issues in this project, always verify the runtime environment first:
1. Check Python version: `python3 --version`
2. Verify installed packages: `pip list`
3. Run environment diagnostics: `python3 -c "import os,sys,platform; print(f'OS: {platform.platform()}\nUser: {os.getenv(\"USER\")}\nHost: {platform.node()}\nPython: {sys.version}')"` 
4. Include diagnostic output in responses for traceability

## Build Commands
- Install: `make build`
- Test: `make test`
- Deploy: `bash config/deploy.sh`
