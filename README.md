## Thesaurus

- `RouteInformation` - The route information consists of a location string of the application
  and a state object that configures the application in that location.
- `OctopusNode` - a node in the navigation graph, a piece of information
  about the current state of the application (e.g. current screen)
- `OctopusState` - router whole application state
- `OctopusPage<T>` - describes the configuration of a [Route].

## Core concepts

Updating applications state from native (e.g. deep links, push notifications, etc.) and web (e.g. links, forms, etc.):

1. `OctopusInformationProvider` - gets information about the current state of the application (e.g. current screen, current user, etc.) and converts it into `RouteInformation`
2. `OctopusInformationParser` - receives `RouteInformation` and converts it through `OctopusNode`s to `OctopusState` tree
3. `OctopusDelegate` - receives `OctopusState` and builds the navigation graph with `OctopusPage`s

## Planned features

1. RouteAware - a widget that is notified when the current route has been pushed or popped.
2. Declarativeness - a way to describe the navigation graph declaratively
3. Nested navigation - a way to describe the nested navigation graph
4. Route guards - a way to prevent navigation to a route
5. Route resolvers - a way to resolve a route to a different route
6. Route transitions - a way to describe the route transitions
7. Route animations - a way to describe the route animations
8.
