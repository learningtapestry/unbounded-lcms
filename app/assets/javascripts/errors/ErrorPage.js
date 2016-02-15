import React from 'react';
import PageNotFound from './PageNotFound';
import GenericError from './GenericError';

export default function errorPage(props) {
  let component;
  
  if (props.error.response.status) {
    component = PageNotFound;
  } else {
    component = GenericError;
  }

  return React.createElement(component, {});
}
