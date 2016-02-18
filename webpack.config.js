var path = require('path');
var webpack = require('webpack');

module.exports = {
  entry: {
    app: path.resolve(__dirname, 'app', 'assets', 'javascripts', 'app', 'bundle.js')
  },
  output: {
    path: path.resolve(__dirname, 'app', 'assets', 'javascripts', 'generated'),
    filename: '[name].js'
  },
  module: {
    loaders: [
      {
        test: /\.jsx?$/,
        loader: 'babel',
        query: {
          presets: ['stage-2', 'react', 'es2015']
        },
        exclude: /node_modules/
      },
      // App components will be compiled with CSS modules enabled.
      {
        test: /\.s?css$/,
        include: [path.resolve(__dirname, 'app', 'assets')],
        loaders: ['style', 'css?modules&importLoaders=1&localIdentName=[name]__[local]___[hash:base64:5]', 'sass']
      },
      // Node modules will be compiled with global CSS, because they are
      // usually meant to be applied globally.
      {
        test: /\.s?css$/,
        include: [path.resolve(__dirname, 'node_modules')],
        loaders: ['style', 'css', 'sass']
      },
      // URL loader for font and image assets.
      {
        test: /\.(eot|woff|woff2|ttf|svg|png|jpe?g|gif)(\?\S*)?$/,
        loader: 'url-loader?limit=100000&name=[name].[ext]'
      },
      { test: require.resolve('react'), loader: 'expose?React' }
    ]
  },
  sassLoader: {
    includePaths: [path.resolve(__dirname, 'app', 'assets', 'javascripts')]
  },
  resolve: {
    root: [path.resolve(__dirname, 'app', 'assets', 'javascripts')]
  }
};
