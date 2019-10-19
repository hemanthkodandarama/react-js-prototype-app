/**
 *
 * LabelWrapper
 *
 */

import styled from 'styled-components';
import { PHONE_LANDSCAPE_VIEWPORT_WIDTH } from 'utils/rwd';
import { PRIMARY_RED } from 'utils/colors';

const LabelWrapper = styled.label`
  margin: ${props => (props.error ? '0 auto' : '10px auto 1px')};
  text-align: left;
  font-size: ${props => (props.error ? '13px' : '18px')};
  letter-spacing: 0.3px;
  width: 90%;
  display: block;
  color: ${props => (props.error ? PRIMARY_RED : 'inherit')};

  @media screen and (min-width: ${PHONE_LANDSCAPE_VIEWPORT_WIDTH}) {
    width: ${props => (props.large ? '315px' : '17rem')};
  }
`;

export default LabelWrapper;
