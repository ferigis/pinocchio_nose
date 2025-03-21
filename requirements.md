# Task Requirements

Please implement a scalable web service which accepts requests to increment a value
associated with a given key. The service must synchronize its state to a Postgres database at
least every ten seconds. Please do not spend more than six hours on this project.
Basics

- The service listens on port 3333 and accepts POST requests at the path /increment
- The request body is key and value in a JSON string with the format `{"key":
"<key_value>", "value": <increment>}`. Both parameters are required.
- Requests increment the given key by the value indicated.
- The persisted state must be, at most, ten seconds out of date.
- After a successful request, the endpoint will respond with HTTP code 202 (accepted)
and an empty body.
Deliverables
- Functional prototype delivered as a Github repo or an archive. It’s considered functional
if all the basic items are covered, working and documented.
- Tests to prove the project and major code flows work.
- Credentials or an invitation for any 3rd party services used in your implementation.
- A brief document explaining why you built it the way you did. Include details of how you
approached persistence as well as your choice of external libraries, homegrown tools or
cloud services (if any).
- A postmortem summarizing your findings. Did it go smoothly? Any surprises or lessons
learned? What performance bottlenecks did you find? Should we implement a
production-ready version of what you built, or would you do things differently if it was
going to production and you had more time?

What We’re Looking For

- Scalable, performant architecture
- Clean and idiomatic code
- Unit test coverage for important functionality
- A thoughtfully written post mortem

## Possible Enhancements (if you find yourself with additional time)

- Implement metrics collection for your service with your favorite strategy/client, including
OSS projects, homegrown tools or cloud services. The only requirement is we can
review all details so if you use services, please provide credentials.
- Add a form of industry-standard authorization to the /increment endpoint. Again, any
OSS or Cloud Service is acceptable so long as we are able to run your code and
authenticate.
- Apply rate-limiting to the endpoint so that a single client can not overwhelm the service.
- Provide benchmarks for your implementation using any benchmarking tool you prefer.