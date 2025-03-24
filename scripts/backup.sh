#!/usr/bin/env bash

bk() {
  cp "$1"{,.backup}
}

trashbk() {
  trash "$1.backup"
}

diffbk() {
  delta "$1"{.backup,}
}