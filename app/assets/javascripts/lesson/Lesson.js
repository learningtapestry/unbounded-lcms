import React from 'react';

export default function lesson(props) {
  const description = { __html: props.description };

  return (
    <div>
      <h1>{props.title}</h1>
      <div dangerouslySetInnerHTML={description}></div>
    </div>
  );
}
