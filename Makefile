.PHONY=clean image kill restart

clean:
	docker rmi fonnesbeck/bayesian_modeling

image:
	docker build -t fonnesbeck/bayesian_modeling .

kill:
	docker stop fonnesbeck/bayesian_modeling
	docker rm fonnesbeck/bayesian_modeling

restart: kill run;