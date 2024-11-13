#!/usr/bin/env python3

import logging
import argparse
import audit
#import backup
#import harden

def main():
    # Set up argument parser
    parser = argparse.ArgumentParser(description="macOS hardening tool with audit, backup, and harden functionalities.")

    # Add positional argument for action (audit, backup, harden)
    parser.add_argument(
        "action", 
        choices=["audit", "backup", "harden"], 
        help="Action to perform: audit, backup, or harden."
    )

    # Add optional argument for config file
    parser.add_argument(
        "--config", 
        default="referentiel.csv", 
        help="Path to the configuration file (default: referentiel.csv)."
    )

    # Add optional argument for output backup file
    parser.add_argument(
        "--output", 
        default="backup.json", 
        help="Path to save the backup file (default: backup.json)."
    )
    
    # Add optional verbose flag
    parser.add_argument(
        "--verbose", 
        action="store_true", 
        help="Enable verbose mode for detailed output."
    )

    # Parse the arguments
    args = parser.parse_args()

    # Set up logging based on the verbose flag
    if args.verbose:
        logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')
    else:
        logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

    # Call the appropriate function based on the action
    if args.action == "audit":
        logging.info("Starting audit...")
        audit.audit(args.config)
    elif args.action == "backup":
        logging.info("Starting backup...")
        #backup.backup(args.config, args.output)
    elif args.action == "harden":
        logging.info("Starting hardening...")
        #harden.harden(args.config)
    else:
        logging.error("Unknown action.")

if __name__ == "__main__":
    main()
