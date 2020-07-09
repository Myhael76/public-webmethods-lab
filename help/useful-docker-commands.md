# Useful Docker Commands

## Cleaning up docker resources

### Prune dangling resources

docker system prune -f

### Prune all, with volumes

docker system prune -a -f --volumes