# 99

99 receives, analyzes, and indexes events.

## Architecture

99 is a system that consists of multiple parts.

### Dashboard

The dashboard is a GUI app for interacting with 99 manually.

### Funnel

The funnel is the thing you send events to from your app.

### Index

The index stores events such that they can be searched through efficiently.

### Handlers

Handlers are Python programs written by the user. These programs are invoked
once for each new event, and can do anything.
