
```bash
cd /var/www/gitlab
```


```bash
HOME=/var/www/gitlab \
bundle exec rake db:migrate RAILS_ENV=production
```

```bash
HOME=/var/www/gitlab \
bundle exec rake assets:clean RAILS_ENV=production
```

```bash
HOME=/var/www/gitlab \
bundle exec rake assets:precompile RAILS_ENV=production
```

```bash
HOME=/var/www/gitlab \
bundle exec rake cache:clear RAILS_ENV=production
```
