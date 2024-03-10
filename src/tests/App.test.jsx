import { render, screen } from '@testing-library/react';
import App from '../App';

test('renders for firstname', () => {
  render(<App />);
  const  firstname= screen.getByText('First name:');
  expect(firstname).toBeInTheDocument();
});

test('renders for lastname', () => {
  render(<App />);
  const  lastname= screen.getByText('Last name:');
  expect(lastname).toBeInTheDocument();
});

test('renders for Email', () => {
  render(<App />);
  const  email= screen.getByText('Email:');
  expect(email).toBeInTheDocument();
});

test('renders for Phone number', () => {
  render(<App />);
  const  phoneNumber= screen.getByText('Phonenumber:');
  expect(phoneNumber).toBeInTheDocument();
});

test('renders for Button Cancel', () => {
  render(<App />);
  const  cancelButton= screen.getByText('Cancel');
  expect(cancelButton).toBeInTheDocument();
});

test('renders for Button Create', () => {
  render(<App />);
  const  createButton= screen.getByText('Create');
  expect(createButton).toBeInTheDocument();
});