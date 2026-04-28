# CloudFormation Parameters: dev

## Files

- `main.example.json`: committed example with safe defaults for the Assignment 01 network and placeholders only for `KeyName` and `ImageId`
- `main.local.json`: local untracked copy with the real runtime values for your AWS account

## Notes

- Keep `main.local.json` out of Git.
- Update `AllowedSshCidr` if your public IP changes.
- Package `templates/main.yaml` before creating or updating the stack.
