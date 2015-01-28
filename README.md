# iskole
School Management System

## Configuration

### Database

To configure database access you need to set following settings accordingly.

File: src/application/config/database.php
```
hostname = localhost
username = user
password = password
database = school
```

### Application Environment

Set application environment in src/index.php

Valid settings: 
 * development
 * testing
 * production

```
define('ENVIRONMENT', 'development');

Change encryption key in src/application/config/config.php

```
encryption_key = demo_encryption_key_1234
```

### Default Settings

To login system uses the username (this can be change to use email by changing $config['identity'] field in src/application/config/ion_auth.php)

Administrator Details:
```
username: admin
email:    admin@iskole.com
passowrd: passowrd
```
