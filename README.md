# docker-status-check-action

This GitHub Action automatically checks if a given container has its status healthy within a given timeout.  

## Usage

Add the following step at the end of your job, after other steps that might add or change files.

```yaml
- uses: meupatrocinio/docker-status-check-action@v1
  with:
    # Required parameter but recommended
    # Container name to be watched
    container_name: strange_wescoff
    # Optional parameter, defaults to 300 seconds
    # in seconds
    timeout: 300
```

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.
