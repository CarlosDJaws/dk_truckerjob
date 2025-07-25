DK Trucker Job for ESX
What is this?
dk_truckerjob is a simple, feature-rich truck driving job script for FiveM servers running the ESX framework. It allows players with the "trucker" job to take on delivery missions, earn money, and interact with various job-related features.

This script is designed to be easy to configure and is optimized to ensure minimal impact on server performance.

This script was made by Dark.

Features
ESX Job Integration: Players must have the trucker job in the database to work.

Delivery Options: Players can choose between two types of deliveries from a menu:

Short Haul: Quicker, local deliveries within the city for smaller payouts.

Long Haul: Longer, cross-country deliveries for larger payouts.

Cloakroom System: Players can change into a pre-configured work uniform (construction worker outfit) and back into their civilian clothes at a designated cloakroom.

Failure Conditions: The job has consequences. A delivery will be automatically cancelled if:

The player's truck is destroyed.

The player dies during the delivery.

Penalty System: If a job is failed, a configurable fee is automatically deducted from the player's bank account for the lost equipment.

Highly Configurable: Almost every aspect of the job can be easily changed in the config.lua file, including all locations, payment amounts, vehicle models, and the penalty fee.

Optimized: The client-side code is written to be efficient, using a single loop and distance checks to minimize resource usage and prevent lag.

Installation
Download the Resource: Place the entire dk_truckerjob folder into your server's resources directory.

Import the SQL: Open the dk_truckerjob.sql file and execute the SQL code in your server's database. This will add the trucker job and the default outfit to your jobs and job_grades tables.

Add to server.cfg: Add the following line to your server.cfg file, ensuring it comes after es_extended and esx_skin:

ensure dk_truckerjob

Restart Your Server: Restart your FiveM server, and the job will be active.

How it Works
A player must first get the trucker job (e.g., from a job center).

Once they have the job, they can go to the Trucker Job Center marked on the map.

At the job center, they can press E to open a menu and choose between a "Short Delivery" or a "Long Delivery".

After selecting a delivery, a truck and trailer will spawn nearby, and the player will be placed inside.

A blip will appear on the map guiding them to a random pickup location.

After reaching the pickup spot, the blip will update to a random drop-off location.

Upon successful completion, the player is paid. If they die or destroy the truck, the mission fails, and they are charged a fee.

Players can also visit the cloakroom at any time to change into their work uniform or back into their civilian clothes.
