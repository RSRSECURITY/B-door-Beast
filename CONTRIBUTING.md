# Contributing to Infinity Beast

Thank you for your interest in contributing to **Infinity Beast**, a PowerShell-based remote access tool for ethical hacking and cybersecurity education! We welcome contributions from the community to make this tool better, safer, and more effective for educational purposes.

## 📜 Rules for Contributing

### 1. Ethical Use Only
- **Infinity Beast** is for **educational and ethical hacking purposes only**. Contributions must align with this goal.
- Do not submit code or features that encourage illegal or unethical use (e.g., harming systems without consent).
- If you’re unsure, ask the maintainers before submitting.

### 2. Use Pull Requests
- All changes to the `main` branch must be submitted via a **pull request (PR)**.
- Direct pushes to `main` are restricted to maintainers (`RSRSECURITY`).
- Steps to submit a PR:
  1. Fork the repository.
  2. Create a new branch (`git checkout -b feature/your-feature-name`).
  3. Make your changes and commit (`git commit -m "Add your feature"`).
  4. Push to your fork (`git push origin feature/your-feature-name`).
  5. Open a pull request on GitHub, targeting the `main` branch.
- Ensure your PR:
  - Has a clear title and description.
  - Resolves any comments or issues raised during review.
  - Requires at least 1 approval before merging.

### 3. Code Quality
- Write clean, readable code with comments where necessary.
- Follow PowerShell best practices (e.g., use meaningful variable names, handle errors with `try/catch`).
- Test your changes on a Windows machine to ensure they work as expected.
- Do not introduce vulnerabilities (e.g., hardcoded credentials, unencrypted data).

### 4. Feature Requests and Bug Reports
- Use GitHub Issues to report bugs or suggest features.
- For bugs:
  - Describe the issue, including steps to reproduce.
  - Include your environment (e.g., Windows version, network setup).
- For features:
  - Explain the feature and why it’s useful.
  - Suggest how it might be implemented.

### 5. Respect the Project’s Scope
- Focus on features that enhance the tool’s educational value (e.g., better stealth, new commands, improved error handling).
- Avoid changes that make the tool harder to use for beginners (e.g., overly complex features).

### 6. Be Respectful
- Follow GitHub’s Community Guidelines.
- Be constructive in feedback and discussions.
- Respect the maintainers’ decisions.

## 🛠️ Development Setup
1. Clone the repo: `git clone https://github.com/RSRSECURITY/Infinity-Beast.git`.
2. Make changes in a new branch.
3. Test locally on a Windows machine with Netcat (`nc -l 4444`) as a listener.
4. Submit a pull request as described above.

## 📋 Example Contribution
- **Feature**: Add a new command to list running processes.
- **Steps**:
  1. Fork and clone the repo.
  2. Create a branch: `git checkout -b feature/list-processes`.
  3. Edit `infinity_beast.ps1` to add a `processes` command using `Get-Process`.
  4. Test by running the script and sending the `processes` command.
  5. Commit and push: `git commit -m "Add processes command" && git push origin feature/list-processes`.
  6. Open a pull request.

## 🤝 Getting Help
- If you have questions, open an issue or reach out to `RSRSECURITY` via GitHub.
- Check the [README](README.md) for setup and usage instructions.

Thank you for helping make **Infinity Beast** better! 🐾
