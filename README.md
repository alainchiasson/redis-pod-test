# Redis Pod persistance and restart test

This is a test for redis persitance with an unstable application in the same pod.

We have a few applicaitons that use a local redis database to cache information.
The gola o using redis is if the application has is restarted, the cached data will
persist - as it can take around 40 minutes o repopulate redis. This is to see if
there is value in a co-located redis pod, as opposed to a redis service.

# Usage

run `make` for help on running the demo



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

I will be trying to use a config map for the startup scripts so I do not need to
build a new pod.
