# Flutter Testing Prompts

## Unit Test Generation Promp
Generate comprehensive unit tests for the provided Flutter code that include:
- Test setup with proper mocking
- Happy path scenarios
- Error case handling
- Edge cases and boundary conditions
- Verify all public methods and properties
- Use meaningful test descriptions
- Follow AAA pattern (Arrange, Act, Assert)

Example request: "Generate unit tests for this UserRepository class"

## Widget Test Generation Promp
Create widget tests that verify:
- Widget renders correctly with different inputs
- User interactions work as expected
- State changes are reflected in UI
- Error states are displayed properly
- Loading states are shown
- Accessibility features work correctly

Example request: "Generate widget tests for this LoginForm widget"

## Integration Test Promp
Create integration tests that:
- Test complete user journeys
- Verify navigation flows
- Test API integrations end-to-end
- Verify data persistence
- Test performance scenarios
- Include error recovery testing

Example request: "Generate integration tests for the user registration flow"

## Mock Generation Promp
Generate mock implementations that:
- Use mocktail or mockito
- Mock all external dependencies
- Include behavior verification
- Handle async operations properly
- Support different test scenarios

Example request: "Generate mocks for this ApiService interface"

## Test Data Generation Promp
Create test data that:
- Covers various scenarios
- Includes edge cases
- Uses factory patterns
- Generates realistic data
- Supports different test contexts

Example request: "Generate test data for User model testing"
