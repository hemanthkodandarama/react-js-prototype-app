import React from 'react';
import { render } from '@testing-library/react';

import ButtonWrapper from '../ButtonWrapper';

describe('<ButtonWrapper />', () => {
  it('should render an <button> tag', () => {
    const { container } = render(<ButtonWrapper />);
    expect(container.querySelector('button')).not.toBeNull();
  });

  it('should have a class attribute', () => {
    const { container } = render(<ButtonWrapper />);
    expect(container.querySelector('button').hasAttribute('class')).toBe(true);
  });

  it('should not adopt an invalid attribute', () => {
    const { container } = render(<ButtonWrapper attribute="test" />);
    expect(container.querySelector('button[attribute="test"]')).toBeNull();
  });
});
