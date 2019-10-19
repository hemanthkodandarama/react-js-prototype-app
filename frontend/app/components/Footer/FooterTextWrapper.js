import styled from 'styled-components';

const FooterTextWrapper = styled.div`
  text-align: left;
  padding: 10px 15px;
  font-size: ${props => props.header && '14px'};
  display: ${props => props.location === '/payment' ? 'none' : props.header ? 'flex' : 'block'};
  align-items: ${props => props.header && 'center'};
`;

export default FooterTextWrapper;
