/**
 *
 * ContentWrapper
 *
 */

import styled from 'styled-components';
import { TOGGLE_TOOLBAR_VIEWPORT_WIDTH } from 'utils/rwd';

const ContentWrapper = styled.main`
  flex-grow: 1;
  padding: 89px 24px 24px;
  position: relative;
  transform: translate(0, 0);
  transition: margin 225ms cubic-bezier(0, 0, 0.2, 1) 0ms;
  margin-left: 0;

  @media screen and (min-width: ${TOGGLE_TOOLBAR_VIEWPORT_WIDTH}) {
    margin-left: ${props => (props.open ? '260px' : '0')};
  }
`;

export default ContentWrapper;
