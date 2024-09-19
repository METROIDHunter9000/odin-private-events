# The Odin Project: Private Events

Private Events is an exercise in ActiveRecord queries and associations. It required critical thought & analysis in designing, implementing, and especially troubleshooting the relationships between the application's models.
This project was a fantastic exercise in the relationships between the Model, the View, and the Controller; how they interface with the outside world using resourceful routing; and how they ultimately organize data within the application's database.

Private Events is a website vaguely mimicking [EventBrite](https://www.eventbrite.com/). Registered users can organize events & RSVP for other people's events. If an organizer marks their event as private, other users must receive an invitation to RSVP, or they must send a request to the organizer, which the organizer can accept to add them to the attendees list.

## Design

The two core models of the application are the "User" and the "Event". Users have a one-to-many relationship with events that they have organized, and a many-to-many relationship with events they are attending. The one-to-many relationship is modeled with a foreign key on the Event model to the organizing User; but the many-to-many relationship is modeled with a join table named "rsvps". This table considers the pairing of a User and an Event, which represents an "RSVP" of the given User going to the given Event.

The implementation of handling RSVPs became a bit more complex when truly "private" events were introduced. Private events cannot be RSVP'ed for - they require the organizer to approve requests made by potential attendees, or they require the potential attendees to accept invitations provided by the organizer. It became evident that more intermediary models (join tables) would be necessary to support inviting users & requesting invitations.

The "EventInvitation" and "EventRequest" join tables therefore also join a User with an Event, with one obvious semantic difference: the former matches an event to a user invited to the event, and the latter matches an event to a user who is requesting to RSVP to the event. These tables are cross-referenced by the RSVP controller to validate whether a given User is allowed to add himself or somebody else to the attendee roster (under the hood, this is done by creating an instance of an RSVP model)

## Setup

Guide to set up this application after cloning:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
