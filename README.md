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
database = student
```

### Application Environment

Set application environment in src/index.php

Valid settings: 
 * development
 * testing
 * production

```
define('ENVIRONMENT', 'development');
