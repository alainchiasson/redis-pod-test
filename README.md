# Redis Pod persistance and restart test

This is a test for redis persitance with an unstable application in the same pod.

We have a few applicaitons that use a local redis database to cache information.
The gola o using redis is if the application has is restarted, the cached data will
persist - as it can take around 40 minutes o repopulate redis. This is to see if
there is value in a co-located redis pod, as opposed to a redis service.

# Usage

run `make` for help on running the demo

```
make
# load                 Load the testscript in the config map
# reload               to update the scrip in the config map.
# deploy               Deploy the redis test to kubernetes
# delete               Delete the deploymnet
# clean                removes everything from kubernetes
# show                 Shows the deployment and pod status
```

# What is going on

The crashing-app is a container that update information in redis database in a
second container within the same pod. The script is :

- get mycounter
- increment mycounter
- sleep 60 seconds
- exit

At this point, kubernetes will restart the failed (stopped) container, which  
will start up the script again.

# Verifying the persistance.

Using the output of `make show` you can find the pod name (see the last line). You
can view the data - either by looking at the logs of the `crashing-app` container
while it is up ( 60 seconds ) :

```
kubectl logs -f <pod-id> -c crashing-app
```

Or you can connect to the redis container and query the database :

```
kubectl exec -ti <pod-id> -c redis redis-cli
get mycounter
```

Or even explore the file system :

```
kubectl exec -ti <pod-id> -c redis /bin/bash
```


## First test

We will create a deployment with a 2 container pod :
- A redis DB (from the standard image)
- A redis client - that does actions, and dies after an amount of time.

The exepected result is that the single conteiner will be restarted, and the redis
database will persist.

## Additional tests or info to be gathered.

- Review monitoring - how to catch the pod failure.
- Review logs - what do we see in the pod failure.
- What if the redis pod is restarted and the app stays up ? is there persistance
- What would cause the entire pod to die ?
- In a multi container pod - there is always the "sleep" container that will keep
  the pod alive. what is the impact of this.

# Implementation details

The startup script for the `crashing-app` iscontainer in a config map file. This 
allows me to inject a stratup script into the standard redis container.
