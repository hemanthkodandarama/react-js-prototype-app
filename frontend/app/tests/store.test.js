/**
 * Test store addons
 */

import { browserHistory } from 'react-router-dom';
import configureStore from '../configureStore';

describe('configureStore params', () => {
  it('should call window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__', () => {
    /* eslint-disable no-underscore-dangle */
    const compose = jest.fn();
    window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ = () => compose;
    configureStore(undefined, browserHistory);
    expect(compose).toHaveBeenCalled();
    /* eslint-enable */
  });
});
