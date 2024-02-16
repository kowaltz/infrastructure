# API

Login to the profile:

```bash
spacectl profile login $PROFILE
```

Retrieve list of dependencies for a stack:

```bash
spacectl stack dependencies on --id=$STACK_ID -o=json
```