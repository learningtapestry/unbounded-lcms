mkdir -p $STACK_BASE/shared/csv_exports
chown -R nginx:app_writers $STACK_BASE/shared/csv_exports
chmod -R 775 $STACK_BASE/shared/csv_exports
chmod -R g+s $STACK_BASE/shared/csv_exports
rm -rf $STACK_PATH/public/csv_exports
ln -nsf $STACK_BASE/shared/csv_exports $STACK_PATH/public/csv_exports

mkdir -p $STACK_BASE/shared/uploads
chown -R nginx:app_writers $STACK_BASE/shared/uploads
chmod -R 775 $STACK_BASE/shared/uploads
chmod -R g+s $STACK_BASE/shared/uploads
rm -rf $STACK_PATH/public/uploads
ln -nsf $STACK_BASE/shared/uploads $STACK_PATH/public/uploads
