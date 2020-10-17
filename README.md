# Traefik v2 Sandbox

This is a sandbox area to play with Traefik v2 in Kubernetes as an ingress.

It contains two simple HTTP services that are deployed side by side in a local
Kubernetes cluster, and then Traefik will route between the two.

This will eventually contain some auth examples and more interesting
configs.  For now, this is just a simple but complete sample of how
to set up Traefik v2 in Kubernetes locally for development purposes.

## Running it

Make sure your `kubectl` is pointing to your local Kubernetes cluster.
The namespace won't matter, a namespace named `traefik-sandbox` will
be created and everything will be put there.

```bash
# This will build the docker images and then deploy to local k8s
make apply

# Run various curl commands to see if we get routed properly
make test
```

If you're running Chrome, you can check the Traefik dashboard at
http://traefik.localhost/dashboard/

## A note on x.localhost domains

If you're using another browser, you'll have to add `traefik.localhost`
to `/etc/hosts` as a localhost endpoint first.  This is because Chrome
assumes any `xyz.localhost` domain is actually trying to hit localhost,
but other browsers assume anything that isn't exactly `localhost` is
trying to hit a real server somewhere else.  This includes curl, which
is why the `make test` command contains `-H "Host: traefik.localhost"`
and so on for its curls.

