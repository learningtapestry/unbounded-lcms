mkdir -p $STACK_BASE/shared/csv_exports
chown nginx:app_writers $STACK_BASE/shared/csv_exports
chmod 775 $STACK_BASE/shared/csv_exports
chmod g+s $STACK_BASE/shared/csv_exports
rm -rf $STACK_PATH/public/csv_exports
ln -nsf $STACK_BASE/shared/csv_exports $STACK_PATH/public/csv_exports
