# Database Component Configurator Container Builder

This project locally builds an optimized docker image containing the database configurator only.

The intention is to use the image to create or upgrade webMethods database schemas on demand, keeping the DBC occupying resources only for the duration of the change run. This may be achieved 100% programatically, thus achieveing perfect repeatability and control.

A secondary use case is quickly and dinamically setup database schemas in ephemeral environments.
