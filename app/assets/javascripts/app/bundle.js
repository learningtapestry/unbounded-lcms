import 'babel-polyfill';

import appStore from './store';
import App from './App';
import ReactOnRails from 'react-on-rails';

global.appStore = appStore;
global.App = App;

ReactOnRails.registerStore({ appStore });
ReactOnRails.register({ App });
