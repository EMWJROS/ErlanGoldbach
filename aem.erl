-module(aem).
-export([findAnswer/0]).
 
%*****************************************************************************
% sieve([],[],List) performs Eratosthenes's Sieve on List of numbers
%*****************************************************************************
sieve(L, [], []) ->
  lists:reverse(L);
sieve([],[],[H|T]) ->
  sieve([H], [], T);
sieve(L, [H|T], []) ->
  sieve([H|L], [], T);
sieve([H1|T1], L, [H2|T2]) when (H2 rem H1) /= 0 ->
  sieve([H1|T1], L++[H2], T2);
sieve([H1|T1], L, [H2|T2]) when (H2 rem H1) == 0 ->
  sieve([H1|T1], L, T2).
 
%******************************************************************************
% primes(N) returns an array of all primes up to N
%******************************************************************************
primes(N) ->
  sieve([],[], lists:seq(3,N,2)).
 
%******************************************************************************
% addSquares([], OriginalList, S) adds twice the squares (1,4,9,...,S^2)
% to all the elements of OriginalList and appends them, sorts
% and removes duplicates
%******************************************************************************
addSquares(L,_,0) ->
  L;
addSquares([], OriginalList, S) ->
  addSquares(OriginalList, OriginalList, S);
addSquares(L, OriginalList, S) ->
  addSquares(lists:usort(L++lists:map(fun(X) -> X+2*S*S end,
                                               OriginalList)),
                                                OriginalList, S-1).
 
%******************************************************************************
% answer(SearchLimit) finds all odd composite numbers
% that can't be written as p+2*n^2 for p<=N and n<sqrt(N)
%******************************************************************************
answer(SearchLimit) ->
  SquareLimit = trunc(math:sqrt(SearchLimit)),
  Primes = primes(SearchLimit),
  OddComposites = lists:seq(3, SearchLimit, 2) -- Primes,
  OddComposites -- lists:filter(fun(X) -> X =< SearchLimit end, addSquares([], 
                                Primes, SquareLimit)).
 
%******************************************************************************
% iterate4Answer(Limit, Increment) tries to find the answer up to
% Limit. If it fails, it increases the limit by Increment and tries again.
%******************************************************************************
iterate4Answer(Limit, Increment) ->
  AnswerList = answer(Limit),
  if
    length(AnswerList) == 0 ->
      iterate4Answer(Limit+Increment, Increment);
    true ->
      [Head, _] = AnswerList,
 Head
  end.
 
%******************************************************************************
% findAnswer() finds the answer to the AEM's question about Life, the
% Universe and Everything.
%******************************************************************************
findAnswer() ->
  iterate4Answer(1000, 1000).
