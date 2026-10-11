# macOS Local Kubernetes Setup

Add these aliases to `~/.zshrc`:

```bash
# Start the local Kubernetes lab
alias k8s-start='colima start && minikube start'

# Stop the local Kubernetes lab
alias k8s-stop='minikube stop && colima stop'
```

Reload the shell configuration to enable the aliases in the current terminal:

```bash
source ~/.zshrc
```

Then start or stop the local Kubernetes lab with:

```bash
k8s-start
k8s-stop
```