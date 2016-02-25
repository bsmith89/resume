### Usage ###

#### Details and metadata ####

Set values in the YAML metadata block.

#### Build ####

`make resume.html`

#### Upload ####

Use the `upload` recipe in Makefile by setting the following variables in
`local.mk`:

```make
SSH_HOST=
SSH_PORT=
SSH_USER=
SSH_TARGET_DIR=
```

### TODO ###

-   Add CSS
-   Add requirements to this README
    -   ghp-import?
    -   pandoc
-   Pare down latex template
