package cgroups

import (
	"strconv"
	"strings"
	"path"

	log "github.com/sirupsen/logrus"
)

type memory string

// GetUsageInBytes returns the current memory in use by the cgroup in bytes
func (c memory) GetUsageInBytes() (int, error) {
	data, err := readFile(string(c), "memory.usage_in_bytes")
	if err != nil {
		return 0, err
	}
	usage, err := strconv.Atoi(strings.TrimSpace(data))
	if err != nil {
		log.Errorf("unable to convert memory usage to integer: %v", err)
		return usage, err
	}
	return usage, nil
}

func (c memory) GetLimitInBytes(slurm bool) (int, error) {
	var memlimitpath string
	// if this is a slurm job cgroup, traverse up to step level as limit on the
	// task level does not contain the correct information
	if slurm == true {
		memlimitpath = path.Dir(string(c))
	} else {
		memlimitpath = string(c)
	}

	data, err := readFile(memlimitpath, "memory.limit_in_bytes")
	if err != nil {
		return 0, err
	}
	usage, err := strconv.Atoi(strings.TrimSpace(data))
	if err != nil {
		log.Errorf("unable to convert memory limit to integer: %v", err)
		return usage, err
	}
	return usage, nil
}
