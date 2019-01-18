# Job Board with Payments

### Description
The basis of this application is a job board where anyone who is looking to get hired can login and apply to the available positions. If you are a user or a company looking to hire can sign up and post a job for a nominal fee.

For the payment, I used Stripe API to initialize a charge when the job is posted

The mail models that are utilized in this project are `User` model and `Job` model

#### Jobs

Each `Job` has the following fields:
* Title - `title:string`
* Logo Avatar - used Carrierwave - `avatar:string`
* Description - `description:text`
* Job URL - `apply_url:string`
* Type - Full-time, Part-time, Contract, Freelance and Internship - `job_type:string`
* Location - `location:string`
* Remote OK - `remote_ok:boolean`
* Company URL - `url:string`
* User ID - `user_id:integer`

#### User

Each `User` has the following fields:

* Name - `name:string`
* Email - `email:string`
* Stripe ID - `stripe_id:string`
* Card Type - `card_type:string`
* Card Last 4 - `card_last4:string`
* Card Expiry Month - `card_exp_month:string`
* Card Expiry Year - `card_exp_year:string`
* Expires at - `expires_at:datetime`
