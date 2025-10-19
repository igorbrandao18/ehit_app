#!/bin/bash

# Fastlane Helper Script for Ehit App
# This script provides easy commands to build and deploy the app

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if we're in the right directory
check_directory() {
    if [ ! -f "ios/fastlane/Fastfile" ]; then
        print_error "Please run this script from the project root directory"
        exit 1
    fi
}

# Function to show usage
show_usage() {
    echo "Ehit App Fastlane Helper"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  beta                    Build and upload to TestFlight"
    echo "  beta-custom [message]   Build and upload to TestFlight with custom changelog"
    echo "  release                 Build and upload to App Store"
    echo "  clean                   Clean Flutter and iOS build artifacts"
    echo "  setup                   Setup Fastlane (first time only)"
    echo "  help                    Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 beta"
    echo "  $0 beta-custom \"Fixed login bug and improved performance\""
    echo "  $0 release"
}

# Function to setup Fastlane
setup_fastlane() {
    print_status "Setting up Fastlane..."
    
    cd ios
    bundle install
    cd ..
    
    print_success "Fastlane setup complete!"
    print_status "You can now use: $0 beta"
}

# Function to clean build artifacts
clean_build() {
    print_status "Cleaning build artifacts..."
    
    flutter clean
    cd ios
    xcodebuild clean -workspace Runner.xcworkspace -scheme Runner
    cd ..
    
    print_success "Build artifacts cleaned!"
}

# Function to build and upload to TestFlight
build_beta() {
    print_status "Building and uploading to TestFlight..."
    
    cd ios
    bundle exec fastlane beta
    cd ..
    
    print_success "Beta build uploaded to TestFlight!"
}

# Function to build and upload to TestFlight with custom changelog
build_beta_custom() {
    local changelog="$1"
    
    if [ -z "$changelog" ]; then
        print_error "Please provide a changelog message"
        echo "Usage: $0 beta-custom \"Your changelog message here\""
        exit 1
    fi
    
    print_status "Building and uploading to TestFlight with custom changelog..."
    print_status "Changelog: $changelog"
    
    cd ios
    bundle exec fastlane beta_with_changelog changelog:"$changelog"
    cd ..
    
    print_success "Beta build uploaded to TestFlight with custom changelog!"
}

# Function to build and upload to App Store
build_release() {
    print_warning "This will upload to the App Store. Are you sure? (y/N)"
    read -r response
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
        print_status "Building and uploading to App Store..."
        
        cd ios
        bundle exec fastlane release
        cd ..
        
        print_success "Release build uploaded to App Store!"
    else
        print_status "Release cancelled."
    fi
}

# Main script logic
main() {
    check_directory
    
    case "${1:-help}" in
        "beta")
            build_beta
            ;;
        "beta-custom")
            build_beta_custom "$2"
            ;;
        "release")
            build_release
            ;;
        "clean")
            clean_build
            ;;
        "setup")
            setup_fastlane
            ;;
        "help"|"--help"|"-h")
            show_usage
            ;;
        *)
            print_error "Unknown command: $1"
            echo ""
            show_usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
